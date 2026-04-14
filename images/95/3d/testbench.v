`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] hilo_w_data_1;
    reg [31:0] hilo_w_data_2;
    reg hilo_w_en_1;
    reg hilo_w_en_2;
    reg reset;
    wire [31:0] hilo_r_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hilo_w_data_1(hilo_w_data_1),
        .hilo_w_data_2(hilo_w_data_2),
        .hilo_w_en_1(hilo_w_en_1),
        .hilo_w_en_2(hilo_w_en_2),
        .reset(reset),
        .hilo_r_data(hilo_r_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            hilo_w_en_1 = 0;
            hilo_w_en_2 = 0;
            hilo_w_data_1 = 32'h0;
            hilo_w_data_2 = 32'h0;
            @(negedge clk);
            #2 reset = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset functionality check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write via hilo_w_en_1", test_num);
            reset_dut();

            @(posedge clk);
            hilo_w_en_1 = 1;
            hilo_w_en_2 = 0;
            hilo_w_data_1 = 32'hAAAA_BBBB;

            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write via hilo_w_en_2", test_num);
            reset_dut();

            @(posedge clk);
            hilo_w_en_1 = 0;
            hilo_w_en_2 = 1;
            hilo_w_data_2 = 32'h5555_6666;

            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h5555_6666);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Priority Check (en2 > en1)", test_num);
            reset_dut();

            @(posedge clk);
            hilo_w_en_1 = 1;
            hilo_w_en_2 = 1;
            hilo_w_data_1 = 32'h1111_1111;
            hilo_w_data_2 = 32'h2222_2222;

            @(negedge clk);
            #2;

            #1;


            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Data retention check (no enable signals)", test_num);
            reset_dut();


            @(posedge clk);
            hilo_w_en_1 = 1;
            hilo_w_data_1 = 32'hDEAD_BEEF;
            @(negedge clk);


            @(posedge clk);
            hilo_w_en_1 = 0;
            hilo_w_en_2 = 0;
            hilo_w_data_1 = 32'h0;
            hilo_w_data_2 = 32'hFFFF_FFFF;

            @(negedge clk);
            #2;

            #1;


            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple sequential writes", test_num);
            reset_dut();


            @(posedge clk);
            hilo_w_en_1 = 1;
            hilo_w_data_1 = 32'h1234_5678;
            @(negedge clk);


            @(posedge clk);
            hilo_w_en_1 = 0;
            hilo_w_en_2 = 1;
            hilo_w_data_2 = 32'h8765_4321;
            @(negedge clk);

            #2;
            #1;

            check_outputs(32'h8765_4321);
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
        input [31:0] expected_hilo_r_data;
        begin
            if (expected_hilo_r_data === (expected_hilo_r_data ^ hilo_r_data ^ expected_hilo_r_data)) begin
                $display("PASS");
                $display("  Outputs: hilo_r_data=%h",
                         hilo_r_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hilo_r_data=%h",
                         expected_hilo_r_data);
                $display("  Got:      hilo_r_data=%h",
                         hilo_r_data);
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
        $dumpvars(0,clk, hilo_w_data_1, hilo_w_data_2, hilo_w_en_1, hilo_w_en_2, reset, hilo_r_data);
    end

endmodule
