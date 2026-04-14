`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg b;
    reg c;
    reg clk;
    reg e;
    reg reset;
    wire cx;
    wire e2;
    wire r_b;
    wire r_c;
    wire r_e;
    wire rb;
    wire rr_b;
    wire rr_e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .c(c),
        .clk(clk),
        .e(e),
        .reset(reset),
        .cx(cx),
        .e2(e2),
        .r_b(r_b),
        .r_c(r_c),
        .r_e(r_e),
        .rb(rb),
        .rr_b(rr_b),
        .rr_e(rr_e)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            b = 0;
            e = 0;
            c = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Pulse Propagation", test_num);
            reset_dut();


            b = 1; e = 1; c = 0;
            @(posedge clk); #1;


            b = 0; e = 0; c = 1;
            @(posedge clk); #1;


            b = 0; e = 0; c = 0;
            @(posedge clk); #1;




            #1;





            check_outputs(1, 1, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pipeline Stream Check", test_num);
            reset_dut();


            b = 1; e = 1; c = 0;
            @(posedge clk); #1;

            b = 1; e = 0; c = 1;
            @(posedge clk); #1;

            b = 0; e = 1; c = 1;
            @(posedge clk); #1;

            b = 0; e = 0; c = 0;
            @(posedge clk); #1;










            #1;











            check_outputs(1, 0, 0, 0, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-operation Reset", test_num);
            reset_dut();

            b = 1; e = 1; c = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_cx;
        input expected_e2;
        input expected_r_b;
        input expected_r_c;
        input expected_r_e;
        input expected_rb;
        input expected_rr_b;
        input expected_rr_e;
        begin
            if (expected_cx === (expected_cx ^ cx ^ expected_cx) &&
                expected_e2 === (expected_e2 ^ e2 ^ expected_e2) &&
                expected_r_b === (expected_r_b ^ r_b ^ expected_r_b) &&
                expected_r_c === (expected_r_c ^ r_c ^ expected_r_c) &&
                expected_r_e === (expected_r_e ^ r_e ^ expected_r_e) &&
                expected_rb === (expected_rb ^ rb ^ expected_rb) &&
                expected_rr_b === (expected_rr_b ^ rr_b ^ expected_rr_b) &&
                expected_rr_e === (expected_rr_e ^ rr_e ^ expected_rr_e)) begin
                $display("PASS");
                $display("  Outputs: cx=%b, e2=%b, r_b=%b, r_c=%b, r_e=%b, rb=%b, rr_b=%b, rr_e=%b",
                         cx, e2, r_b, r_c, r_e, rb, rr_b, rr_e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cx=%b, e2=%b, r_b=%b, r_c=%b, r_e=%b, rb=%b, rr_b=%b, rr_e=%b",
                         expected_cx, expected_e2, expected_r_b, expected_r_c, expected_r_e, expected_rb, expected_rr_b, expected_rr_e);
                $display("  Got:      cx=%b, e2=%b, r_b=%b, r_c=%b, r_e=%b, rb=%b, rr_b=%b, rr_e=%b",
                         cx, e2, r_b, r_c, r_e, rb, rr_b, rr_e);
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
        $dumpvars(0,b, c, clk, e, reset, cx, e2, r_b, r_c, r_e, rb, rr_b, rr_e);
    end

endmodule
