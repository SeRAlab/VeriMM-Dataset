`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] avl_address;
    reg clk;
    reg [15:0] current_instr;
    reg [9:0] current_pc;
    reg [4:0] current_state;
    reg reset;
    wire [15:0] avl_readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avl_address(avl_address),
        .clk(clk),
        .current_instr(current_instr),
        .current_pc(current_pc),
        .current_state(current_state),
        .reset(reset),
        .avl_readdata(avl_readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            avl_address = 0;
            current_instr = 0;
            current_pc = 0;
            current_state = 0;
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
            reset = 1;
            current_instr = 16'hFFFF;
            avl_address = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            current_instr = 16'hABCD;
            avl_address = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            current_pc = 10'h2A3;
            avl_address = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h02A3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_state = 5'h15;
            avl_address = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0015);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            current_pc = 10'h3FF;
            avl_address = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h03FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            current_state = 5'h1F;
            avl_address = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h001F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();


            current_instr = 16'h1111;
            avl_address = 2'b00;
            @(posedge clk);
            #1;


            current_pc = 10'h088;
            avl_address = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0088);
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
        testcase007();
        
        
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
        input [15:0] expected_avl_readdata;
        begin
            if (expected_avl_readdata === (expected_avl_readdata ^ avl_readdata ^ expected_avl_readdata)) begin
                $display("PASS");
                $display("  Outputs: avl_readdata=%h",
                         avl_readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avl_readdata=%h",
                         expected_avl_readdata);
                $display("  Got:      avl_readdata=%h",
                         avl_readdata);
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
        $dumpvars(0,avl_address, clk, current_instr, current_pc, current_state, reset, avl_readdata);
    end

endmodule
