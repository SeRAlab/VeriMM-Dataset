`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr0;
    reg [9:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [31:0] d0;
    reg we0;
    wire [31:0] q0;
    wire [31:0] q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .d0(d0),
        .we0(we0),
        .q0(q0),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr0 = 0;
        addr1 = 0;
        ce0 = 0;
        ce1 = 0;
        d0 = 0;
        we0 = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %03d: Port A Write/Read", test_num);


        @(negedge clk);
        addr0 = 10'h005; d0 = 32'hDEADBEEF; ce0 = 1; we0 = 1;
        @(negedge clk);
        we0 = 0;


        addr0 = 10'h005; ce0 = 1; ce1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, q1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %03d: Port A Write, Port B Read", test_num);


        @(negedge clk);
        addr0 = 10'd10; d0 = 32'hCAFEBABE; ce0 = 1; we0 = 1;
        @(negedge clk);
        we0 = 0; ce0 = 0;


        addr1 = 10'd10; ce1 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(q0, 32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %03d: Simultaneous Ops (Diff Addr)", test_num);


        @(negedge clk);
        addr0 = 10'd50; d0 = 32'h11112222; ce0 = 1; we0 = 1;
        @(negedge clk);


        addr0 = 10'd60; d0 = 32'h33334444; we0 = 1; ce0 = 1;
        addr1 = 10'd50; ce1 = 1;
        @(negedge clk);
        we0 = 0; ce0 = 1; addr0 = 10'd60;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h33334444, 32'h11112222);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %03d: Write Enable Test", test_num);


        @(negedge clk);
        addr0 = 10'd100; d0 = 32'hFFFFFFFF; ce0 = 1; we0 = 0;
        @(negedge clk);



        addr0 = 10'd100; ce0 = 1;
        @(posedge clk);
        #1;
        if (q0 === 32'hFFFFFFFF) begin
            $display("FAIL: Data written while we0 was low!");
            fail_count = fail_count + 1;
        end else begin
            $display("PASS: Data inhibited by we0");
            pass_count = pass_count + 1;
        end
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %03d: Chip Enable Test", test_num);


        @(negedge clk);
        addr0 = 10'd200; d0 = 32'hABCDE001; ce0 = 0; we0 = 1;
        @(negedge clk);


        addr0 = 10'd200; ce0 = 1; we0 = 0;
        @(posedge clk);
        #1;
        if (q0 === 32'hABCDE001) begin
            $display("FAIL: Data written while ce0 was low!");
            fail_count = fail_count + 1;
        end else begin
            $display("PASS: Data inhibited by ce0");
            pass_count = pass_count + 1;
        end
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %03d: Boundary Address (1023)", test_num);

        @(negedge clk);
        addr0 = 10'd1023; d0 = 32'h55AA55AA; ce0 = 1; we0 = 1;
        @(negedge clk);
        we0 = 0; addr0 = 10'd1023; addr1 = 10'd1023; ce1 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h55AA55AA, 32'h55AA55AA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_q0;
        input [31:0] expected_q1;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h",
                         q0, q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h",
                         expected_q0, expected_q1);
                $display("  Got:      q0=%h, q1=%h",
                         q0, q1);
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d0, we0, q0, q1);
    end

endmodule
