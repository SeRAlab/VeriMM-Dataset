`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            load = 0;
            data_in = 8'h00;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial Reset Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic Load Operation");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hA5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Hold Value Check (load=0)");
            test_num = 3;
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h5A;
            @(negedge clk);

            load = 0;
            data_in = 8'hFF;
            @(negedge clk);

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Synchronous Reset Priority Check");
            test_num = 4;
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            rst = 1;
            @(negedge clk);
            rst = 0;
            load = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Sequential Load Operation");
            test_num = 5;
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'h11;
            @(negedge clk);
            data_in = 8'h22;
            @(negedge clk);
            data_in = 8'h33;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Loading 0x00 via Load Enable");
            test_num = 6;
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);

            data_in = 8'h00;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Loading 0xFF");
            test_num = 7;
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit Testbench");
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
        $dumpvars(0,clk, data_in, load, rst, data_out);
    end

endmodule
