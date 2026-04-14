`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] offset;
    reg reset;
    reg valid_in;
    reg [1:0] vpage;
    wire [3:0] pframe;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .clk(clk),
        .offset(offset),
        .reset(reset),
        .valid_in(valid_in),
        .vpage(vpage),
        .pframe(pframe),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            offset = 0;
            valid_in = 0;
            vpage = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Check initial invalid state after reset", test_num);
            reset_dut();


            vpage = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000, 1'b0);


            vpage = 2'b10;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Map Page 1 as valid", test_num);
            reset_dut();


            vpage = 2'b01;
            valid_in = 1'b1;
            offset = 4'hA;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple page mapping test", test_num);
            reset_dut();


            vpage = 2'b00; valid_in = 1'b1;
            @(posedge clk); #1;


            vpage = 2'b11; valid_in = 1'b1;
            @(posedge clk); #1;


            vpage = 2'b11;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0011, 1'b1);


            vpage = 2'b01; valid_in = 1'b0;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0001, 1'b0);


            vpage = 2'b00;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Offset invariance test", test_num);
            reset_dut();


            vpage = 2'b10; valid_in = 1'b1; offset = 4'h0;
            @(posedge clk); #1;


            offset = 4'hF;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Invalidation test", test_num);
            reset_dut();


            vpage = 2'b01; valid_in = 1'b1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0001, 1'b1);


            vpage = 2'b01; valid_in = 1'b0;
            @(posedge clk); #1;


            #1;



            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Mid-operation reset test", test_num);
            reset_dut();


            vpage = 2'b10; valid_in = 1'b1;
            @(posedge clk); #1;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;


            vpage = 2'b10;
            @(posedge clk); #1;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
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
        input [3:0] expected_pframe;
        input expected_valid_out;
        begin
            if (expected_pframe === (expected_pframe ^ pframe ^ expected_pframe) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: pframe=%h, valid_out=%b",
                         pframe, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pframe=%h, valid_out=%b",
                         expected_pframe, expected_valid_out);
                $display("  Got:      pframe=%h, valid_out=%b",
                         pframe, valid_out);
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
        $dumpvars(0,clk, offset, reset, valid_in, vpage, pframe, valid_out);
    end

endmodule
