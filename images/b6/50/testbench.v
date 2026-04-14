`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ra1;
    reg [2:0] ra2;
    reg rst;
    reg [2:0] wa;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .rst(rst),
        .wa(wa),
        .wd(wd),
        .we(we),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        we = 0;
        wa = 3'b0;
        wd = 32'b0;
        ra1 = 3'b0;
        ra2 = 3'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset initialization check", test_num);
        reset_dut();
        ra1 = 3'd3;
        ra2 = 3'd7;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single write, dual read check", test_num);
        reset_dut();

        we = 1;
        wa = 3'd4;
        wd = 32'hDEADBEEF;
        @(posedge clk);
        #1 we = 0;

        ra1 = 3'd4;
        ra2 = 3'd4;
        #2;
        #1;

        check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Multiple registers write/read", test_num);
        reset_dut();

        we = 1; wa = 3'd1; wd = 32'h11111111;
        @(posedge clk);

        wa = 3'd2; wd = 32'h22222222;
        @(posedge clk);
        #1 we = 0;

        ra1 = 3'd1;
        ra2 = 3'd2;
        #2;
        #1;

        check_outputs(32'h11111111, 32'h22222222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Write Enable (WE) gating check", test_num);
        reset_dut();

        we = 0;
        wa = 3'd5;
        wd = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        ra1 = 3'd5;
        ra2 = 3'd0;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Overwrite register data check", test_num);
        reset_dut();

        we = 1; wa = 3'd6; wd = 32'hAAAA_AAAA;
        @(posedge clk);

        wa = 3'd6; wd = 32'h5555_5555;
        @(posedge clk);
        #1 we = 0;
        ra1 = 3'd6;
        ra2 = 3'd0;
        #2;
        #1;

        check_outputs(32'h5555_5555, 32'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file Testbench");
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,clk, ra1, ra2, rst, wa, wd, we, rd1, rd2);
    end

endmodule
