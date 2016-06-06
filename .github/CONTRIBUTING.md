# Contributing to PiPot

This document contains guidelines how to contribute to PiPot by reporting 
issues and contributing to the source code.

#### Table Of Contents

[Code of Conduct](#code-of-conduct)

[How Can I Contribute?](#how-can-i-contribute)
  * [Reporting Bugs](#reporting-bugs)
  * [Suggesting Enhancements](#suggesting-enhancements)
  * [Your First Code Contribution](#your-first-code-contribution)
  * [Pull Requests](#pull-requests)

[Style-guides](#style-guides)
  * [Git Commit Messages](#git-commit-messages)
  * [Specs Styleguide](#specs-styleguide)

## Code of Conduct

This project has a [code of conduct](CODE_OF_CONDUCT.md), based on the 
Contributor Covenant. By participating, you are expected to uphold this code.
Please report unacceptable behavior to `pipot AT canihavesome DOT coffee`.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for PiPot. Following 
these guidelines helps maintainers and the community understand your report, 
reproduce the behavior, and find related reports.

Before creating bug a report, please **search through the issues**
as you might find out that you don't need to create one. If you find an issue 
that represents yours, add a comment to the that issue instead of opening a 
new one. When you are creating a bug report, please include as many details as
possible by looking at the next section.

#### How Do I Submit A (Good) Bug Report?

Explain the problem and include additional details to help maintainers 
reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details 
as possible. For example, start by explaining how you are using PiPot, e.g. 
how many deployments you have, what kind of connection is used for 
communication between the collector and the honeypots, and so on. When listing
steps, **don't just say what you did, but explain how you did it**. 
* **Provide specific examples to demonstrate the steps**. Include links to 
files or GitHub projects, or copy/pasteable snippets, which you use in those 
examples. If you're providing snippets in the issue, use Markdown code blocks.
* **Describe the behavior you observed after following the steps** and point 
out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **If you're reporting that PiPot crashed**, include a crash report with a 
stack trace from the operating system. Please include the crash report in the 
issue in a code block, a file attachment, or in a 
[gist](https://gist.github.com/) and provide link to that gist.
* **If the problem wasn't triggered by a specific action**, describe what you 
were doing before the problem happened and share more information using the 
guidelines below.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new 
version of PiPot) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem 
in an older version of PiPot?** What's the most recent version in which the 
problem doesn't happen? You can download older versions of PiPot from 
[the releases page](https://github.com/PiPot/PiPot/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how 
often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

* **Which version of PiPot are you using?** You can get the exact version by 
checking on the About page on the server.
* **Which services do you have installed?**

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for 
PiPot, including completely new features and minor improvements to existing 
functionality. Following these guidelines helps maintainers and the community 
understand your suggestion and find related suggestions.

Before creating enhancement suggestions, please check if there's already an
enhancement request for your suggestion. If you are suggesting a new 
enhancement, please make sure you follow these guidelines:

* **Use a clear and descriptive title** for the issue to identify the 
suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as 
many details as possible.
* **Provide specific examples to demonstrate the steps**. Include 
copy/pasteable snippets which you use in those examples, as code blocks.
* **Describe the current behavior** and **explain which behavior you expected 
to see instead** and why.

### Your First Code Contribution

Unsure where to begin contributing to PiPot? You can start by looking through 
issues tagged with `help-wanted`.

### Pull Requests

* Follow the styleguides (see next chapter).
* Make sure you document the new code.
* End files with a newline.

## Style-guides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally

### Python Style-guide

Please follow [PEP-8](http://www.python.org/dev/peps/pep-0008/).
