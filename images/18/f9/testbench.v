`timescale 1ns/1ps

module simple_des_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] key;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 8'h0;
            key = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in = 8'h00;
            key = 4'h0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=00, Key=0", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 8'hFF;
            key = 4'hF;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=FF, Key=F", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 8'h80;
            key = 4'h0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=80, Key=0", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 8'h01;
            key = 4'h0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=01, Key=0", test_num);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 8'hAA;
            key = 4'h5;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=AA, Key=5", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data_in = 8'hC0;
            key = 4'h3;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=C0, Key=3", test_num);
            #1;

            check_outputs(8'hE7);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data_in = 8'h5A;
            key = 4'h5;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=5A, Key=5", test_num);
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            data_in = 8'h12;
            key = 4'h3;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Input=12, Key=3", test_num);
            #1;

            check_outputs(8'h42);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, data_in, key, data_out);
    end

endmodule
