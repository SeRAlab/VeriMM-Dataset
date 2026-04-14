`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key0;
    reg [31:0] key1;
    reg [31:0] key2;
    reg [31:0] key3;
    reg [31:0] nonce0;
    reg [31:0] nonce1;
    reg rst;
    wire [31:0] out0;
    wire [31:0] out1;
    wire [31:0] out2;
    wire [31:0] out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_quarter_round dut (
        .clk(clk),
        .key0(key0),
        .key1(key1),
        .key2(key2),
        .key3(key3),
        .nonce0(nonce0),
        .nonce1(nonce1),
        .rst(rst),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key0 = 0; key1 = 0; key2 = 0; key3 = 0;
            nonce0 = 0; nonce1 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeros...");
            reset_dut();
            key0 = 32'h0; key1 = 32'h0; nonce0 = 32'h0; nonce1 = 32'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: All Ones...");
            reset_dut();
            key0 = 32'hFFFFFFFF; key1 = 32'hFFFFFFFF;
            nonce0 = 32'hFFFFFFFF; nonce1 = 32'hFFFFFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hEFFFFFFD, 32'hF789008F, 32'hEEFFEDFE, 32'hEEFFFDEF);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simple Pattern (1, 1, 1, 1)...");
            reset_dut();
            key0 = 32'h1; key1 = 32'h1; nonce0 = 32'h1; nonce1 = 32'h1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Hex Pattern (11, 22, 33, 44)...");
            reset_dut();
            key0 = 32'h11111111; key1 = 32'h22222222;
            nonce0 = 32'h33333333; nonce1 = 32'h44444444;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hBBBBBBBB, 32'hFFFFFFFF, 32'h77777776, 32'hCCCCCCCC);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Complex Values...");
            reset_dut();
            key0 = 32'h87654321; key1 = 32'h12345678;
            nonce0 = 32'hDEADBEEF; nonce1 = 32'h01234567;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h19B6B489, 32'hEACAC04A, 32'h15C88B70, 32'h582C33C7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_quarter_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_out0;
        input [31:0] expected_out1;
        input [31:0] expected_out2;
        input [31:0] expected_out3;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
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
        $dumpvars(0,clk, key0, key1, key2, key3, nonce0, nonce1, rst, out0, out1, out2, out3);
    end

endmodule
