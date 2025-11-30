extends Node

enum RESULT { PERFECT, OKAY, BAD }
enum OPTION { COCOA, MILK, MARSHMELLOWS, WHIPPED_CREAM, STRAW }
enum HOLD { CUP, MILK, MARSHMELLOWS, WHIPPED_CREAM, STRAW, NOTHING }
enum INTERACTABLE { CUPS, STRAWS, COCOA_MACHINE, CUPHOLDER, WHIPPED_CREAM, MILK, MARSHMELLOWS }
enum CHARACTERS { ALPH, BALLOON_BOY, CLOID, FLAM, ICIE, KAROT, SLUSH, SUNNIE, TREE_VI, VISI }

var dialog := {
	CHARACTERS.ALPH: {
		"order": [OPTION.COCOA, OPTION.MARSHMELLOWS],
		"order_message": "just a classic hot cocoa with marshmellows, please. i don't need nothing fancy, the simple things are always the best.",
		"responses": {
			RESULT.PERFECT: "perfect! simple and sweet, just how i like it. remind me to come here more often :D",
			RESULT.OKAY: "it's nice, but not quite what i really had in mind.",
			RESULT.BAD: "oh... this is different than what i had expected..",
		}
	},
	CHARACTERS.BALLOON_BOY: {
		"order": [OPTION.MILK, OPTION.STRAW],
		"order_message": "could i get a cup of milk with a straw please? i'm practicing my bubble blowing and without it i can't make the really big, floaty ones!",
		"responses": {
			RESULT.PERFECT: "yay! now i can make the biggest milk bubbles ever!!",
			RESULT.OKAY: "hmmm, i guess this will work for smaller bubbles.",
			RESULT.BAD: "my bubble dreams are popped... :(",
		}
	},
	CHARACTERS.CLOID: {
		"order": [OPTION.COCOA, OPTION.WHIPPED_CREAM],
		"order_message": "i'm craving something simple.. just sweet and creamy will do. this will be my essential fuel for the journey up the mountain!",
		"responses": {
			RESULT.PERFECT: "excellent service.. just what i needed. thank you.",
			RESULT.OKAY: "it'll do.",
			RESULT.BAD: "not quite the service I was hoping for.",
		}
	},
	CHARACTERS.FLAM: {
		"order": [OPTION.COCOA, OPTION.MILK],
		"order_message": "um- excuse me? could i try the cocoa with milk? i'm still figuring out what i like here and that sounds like a safe place to start-",
		"responses": {
			RESULT.PERFECT: "oh wow, this is amazing! i'll definitely come back!",
			RESULT.OKAY: "it's nice.. i think?",
			RESULT.BAD: "maybe hot drinks aren't for me after all...",
		}
	},
	CHARACTERS.ICIE: {
		"order": [OPTION.COCOA, OPTION.WHIPPED_CREAM, OPTION.MARSHMELLOWS],
		"order_message": "give me the works without milk. make it look cool, but don't make a big deal about it. just keeping it chill, you know?",
		"responses": {
			RESULT.PERFECT: "not bad. actually, pretty decent. cool.",
			RESULT.OKAY: "it's fine, whatever.",
			RESULT.BAD: "meh, seen better.",
		}
	},
	CHARACTERS.KAROT: {
		"order": [OPTION.COCOA, OPTION.MILK, OPTION.MARSHMELLOWS, OPTION.WHIPPED_CREAM, OPTION.STRAW],
		"order_message": "i need the ultimate experience!! give me everything you've gottttttttttt- this drink should be an event!",
		"responses": {
			RESULT.PERFECT: "incredible! this is what dreams are made of!",
			RESULT.OKAY: "it's good, but i expected more up here!",
			RESULT.BAD: "what the hell is this?! curse you!",
		}
	},
	CHARACTERS.SLUSH: {
		"order": [OPTION.COCOA, OPTION.STRAW],
		"order_message": "ooh cocoa with a straw pls! i love the slurpy sounds it makes when you get to the bottom and it's all bubbly and fun! the noise is the best part!",
		"responses": {
			RESULT.PERFECT: "yay! this is so much fun! listen to these awesome slurping noises!",
			RESULT.OKAY: "it's pretty good i guess, but the slurping could be better",
			RESULT.BAD: "aww, the slurping potential here is just disappointing.",
		}
	},
	CHARACTERS.SUNNIE: {
		"order": [OPTION.MILK, OPTION.MARSHMELLOWS],
		"order_message": "some refreshing milk with marshmellows to share with a friend! nothing brings people together like a sweet treat and good conversation, don't ya think?",
		"responses": {
			RESULT.PERFECT: "this is absolutely wonderful! so heartwarming...",
			RESULT.OKAY: "it's nice enough, thank you partner.",
			RESULT.BAD: "oh dear, this might not brighten anyone's day..",
		}
	},
	CHARACTERS.TREE_VI: {
		"order": [OPTION.COCOA, OPTION.WHIPPED_CREAM, OPTION.STRAW],
		"order_message": "heya! i'll take your fanciest cocoa with whipped cream and a cute straw! something that looks as fun as my weekend plans!",
		"responses": {
			RESULT.PERFECT: "wowzers.. i applaud you, my barista.",
			RESULT.OKAY: "it's pretty good, definitely shareable with friends.",
			RESULT.BAD: "well, we can still have fun with it, i suppose!",
		}
	},
	CHARACTERS.VISI: {
		"order": [OPTION.COCOA, OPTION.MILK, OPTION.MARSHMELLOWS, OPTION.WHIPPED_CREAM, OPTION.STRAW],
		"order_message": "um, just a simple hot chocolate please.. maybe with some marshmellows.. and milk.. with whipped on the top... and a straw. I- if that's not too much trouble.. thank you.",
		"responses": {
			RESULT.PERFECT: "oh, this is exactly what i needed... so warm and comforting- thank you again",
			RESULT.OKAY: "it's nice.. just a little different than i imagined.",
			RESULT.BAD: "oh.. um, it's fine. really. i'm sure it's just me.",
		}
	}
}
