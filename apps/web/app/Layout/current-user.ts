import { getCurrentUser } from "@cap/database/auth/session";
import { userIsPro } from "@cap/utils";
import { ImageUploads } from "@cap/web-backend";
import { Effect } from "effect";

export const resolveCurrentUser = Effect.gen(function* () {
	const user = yield* Effect.promise(() => getCurrentUser());
	if (!user) return null;

	const imageUploads = yield* ImageUploads;

	const imageUrl = user.image
		? yield* imageUploads
				.resolveImageUrl(user.image)
				.pipe(Effect.catchAll(() => Effect.succeed(null)))
		: null;

	return {
		id: user.id,
		name: user.name,
		lastName: user.lastName,
		defaultOrgId: user.defaultOrgId,
		email: user.email,
		imageUrl,
		isPro: userIsPro(user),
	};
}).pipe(
	Effect.catchAll((error: unknown) => {
		console.error("Error resolving current user:", error);
		return Effect.succeed(null);
	})
);
