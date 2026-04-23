# MCP Server Setup

## DeepWiki

AI-powered documentation for any GitHub repository. Ask Claude questions about a codebase and get answers grounded in the actual source.

### Install

```bash
claude mcp add -s user -t http deepwiki https://mcp.deepwiki.com/mcp
```

### Verify

```bash
claude mcp list
```

Should show `deepwiki: https://mcp.deepwiki.com/mcp (HTTP) - ✓ Connected`

### Usage

Ask Claude Code: *"What does the anthropics/claude-code repo do?"* — it will query DeepWiki and answer from the real codebase.
