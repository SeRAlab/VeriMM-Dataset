`timescale 1ns/1ps

module conv_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire data_out1;
    wire data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv_encoder Testbench");
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
        input expected_data_out1;
        input expected_data_out2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%b, data_out2=%b",
                         data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%b, data_out2=%b",
                         expected_data_out1, expected_data_out2);
                $display("  Got:      data_out1=%b, data_out2=%b",
                         data_out1, data_out2);
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
        $dumpvars(0,clk, data_in, rst, data_out1, data_out2);
    end

endmodule
