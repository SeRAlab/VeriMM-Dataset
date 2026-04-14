`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c_ck;
    reg c_en;
    reg c_ncs;
    reg [3:0] c_se;
    reg [7:0] c_so;
    reg [3:0] p_si;
    wire [7:0] c_si;
    wire p_ck;
    wire p_ncs;
    wire [3:0] p_se;
    wire [3:0] p_so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_ck(c_ck),
        .c_en(c_en),
        .c_ncs(c_ncs),
        .c_se(c_se),
        .c_so(c_so),
        .p_si(p_si),
        .c_si(c_si),
        .p_ck(p_ck),
        .p_ncs(p_ncs),
        .p_se(p_se),
        .p_so(p_so)
    );

    // Clock generation (10ns period)
    initial begin
        c_ck = 0;
        forever #5 c_ck = ~c_ck;
    end

        task reset_dut;

        begin
            c_en = 0;
            c_ncs = 1;
            c_se = 4'h0;
            c_so = 8'h00;
            p_si = 4'h0;

            @(negedge c_ck);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: Basic Enable and Transfer", test_num);
            reset_dut();

            c_en = 1;
            c_ncs = 0;
            c_se = 4'hA;
            c_so = 8'hB5;


            p_si = 4'h3;
            @(posedge c_ck);
            #2;


            p_si = 4'hC;
            @(negedge c_ck);
            #2;




            #1;





            check_outputs(8'hC3, 0, 0, 4'hA, 4'hB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: Disabled Operation (c_en=0)", test_num);
            reset_dut();

            c_en = 0;
            c_ncs = 0;
            c_se = 4'hF;
            c_so = 8'hFF;
            p_si = 4'hF;

            @(posedge c_ck);
            #2;
            @(negedge c_ck);
            #2;


            #1;



            check_outputs(8'h00, 0, 1, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: Inactive Chip Select (c_ncs=1)", test_num);
            reset_dut();

            c_en = 1;
            c_ncs = 1;
            c_se = 4'h5;
            c_so = 8'h12;
            p_si = 4'h7;

            @(posedge c_ck);
            #2;
            @(negedge c_ck);
            #2;


            #1;



            check_outputs(8'h77, 0, 1, 4'h5, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: Max Value Pattern Transfer", test_num);
            reset_dut();

            c_en = 1;
            c_ncs = 0;
            c_se = 4'hF;
            c_so = 8'hFF;

            p_si = 4'hF;
            @(posedge c_ck);
            #2;
            p_si = 4'hF;
            @(negedge c_ck);
            #2;

            #1;


            check_outputs(8'hFF, 0, 0, 4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();

            c_en = 1;
            c_ncs = 0;
            c_se = 4'h5;
            c_so = 8'hAA;

            p_si = 4'h5;
            @(posedge c_ck);
            #2;
            p_si = 4'hA;
            @(negedge c_ck);
            #2;



            #1;




            check_outputs(8'hA5, 0, 0, 4'h5, 4'hA);
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
        input [7:0] expected_c_si;
        input expected_p_ck;
        input expected_p_ncs;
        input [3:0] expected_p_se;
        input [3:0] expected_p_so;
        begin
            if (expected_c_si === (expected_c_si ^ c_si ^ expected_c_si) &&
                expected_p_ck === (expected_p_ck ^ p_ck ^ expected_p_ck) &&
                expected_p_ncs === (expected_p_ncs ^ p_ncs ^ expected_p_ncs) &&
                expected_p_se === (expected_p_se ^ p_se ^ expected_p_se) &&
                expected_p_so === (expected_p_so ^ p_so ^ expected_p_so)) begin
                $display("PASS");
                $display("  Outputs: c_si=%h, p_ck=%b, p_ncs=%b, p_se=%h, p_so=%h",
                         c_si, p_ck, p_ncs, p_se, p_so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_si=%h, p_ck=%b, p_ncs=%b, p_se=%h, p_so=%h",
                         expected_c_si, expected_p_ck, expected_p_ncs, expected_p_se, expected_p_so);
                $display("  Got:      c_si=%h, p_ck=%b, p_ncs=%b, p_se=%h, p_so=%h",
                         c_si, p_ck, p_ncs, p_se, p_so);
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
        $dumpvars(0,c_ck, c_en, c_ncs, c_se, c_so, p_si, c_si, p_ck, p_ncs, p_se, p_so);
    end

endmodule
