`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] v0;
    reg [31:0] v1;
    reg [31:0] v2;
    reg [31:0] v3;
    wire [31:0] o0;
    wire [31:0] o1;
    wire [31:0] o2;
    wire [31:0] o3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .clk(clk),
        .rst(rst),
        .v0(v0),
        .v1(v1),
        .v2(v2),
        .v3(v3),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            v0 = 0;
            v1 = 0;
            v2 = 0;
            v3 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: All Zeros");
            reset_dut();
            v0 = 32'h00000000;
            v1 = 32'h00000000;
            v2 = 32'h00000000;
            v3 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Unit Inputs");
            reset_dut();
            v0 = 32'h00000001;
            v1 = 32'h00000001;
            v2 = 32'h00000001;
            v3 = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: RFC 7539 Vector");
            reset_dut();
            v0 = 32'h11111111;
            v1 = 32'h01020304;
            v2 = 32'h9b8d6f43;
            v3 = 32'h01234567;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Arbitrary Pattern 1");
            reset_dut();
            v0 = 32'h87654321;
            v1 = 32'h12345678;
            v2 = 32'habcdef01;
            v3 = 32'h13579bdf;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h9c95115b, 32'ha5bc77a1, 32'h41b00f2d, 32'hd39b955e);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Arbitrary Pattern 2");
            reset_dut();
            v0 = 32'hdeadbeef;
            v1 = 32'hcafebebe;
            v2 = 32'hfacefeed;
            v3 = 32'hbaaaaad1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h24664f38, 32'h36784ecb, 32'heca52116, 32'h1a5c0ef3);
        end
        endtask

    task testcase006;

        begin
            $display("Running Test Case 006: Overflow/Masking");
            reset_dut();
            v0 = 32'hffffffff;
            v1 = 32'h00000001;
            v2 = 32'h00000000;
            v3 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_o0;
        input [31:0] expected_o1;
        input [31:0] expected_o2;
        input [31:0] expected_o3;
        begin
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%h, o2=%h, o3=%h",
                         o0, o1, o2, o3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%h, o2=%h, o3=%h",
                         expected_o0, expected_o1, expected_o2, expected_o3);
                $display("  Got:      o0=%h, o1=%h, o2=%h, o3=%h",
                         o0, o1, o2, o3);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, rst, v0, v1, v2, v3, o0, o1, o2, o3);
    end

endmodule
