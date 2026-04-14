`timescale 1ns/1ps

module reg_8bit_sync_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst_n;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_8bit_sync dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            clear = 0;
            data_in = 8'h00;

            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Asynchronous Reset", test_num);
            reset_dut();
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load 0xAA", test_num);
            reset_dut();

            data_in = 8'hAA;
            load = 1;
            clear = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load 0x55", test_num);
            reset_dut();

            data_in = 8'h55;
            load = 1;
            clear = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hold Verification", test_num);
            reset_dut();


            data_in = 8'hF0;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            data_in = 8'h0F;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Clear Verification", test_num);
            reset_dut();


            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            clear = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Clear over Load)", test_num);
            reset_dut();


            data_in = 8'hCC;
            load = 1;
            clear = 1;

            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sequential Loads", test_num);
            reset_dut();

            load = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);

            #1 #1;
 check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_8bit_sync Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clear, clk, data_in, load, rst_n, data_out);
    end

endmodule
