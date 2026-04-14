`timescale 1ns/1ps

module bluetooth_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg reset;
    wire [3:0] encoded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_encoder dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .encoded_data(encoded_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 0 (Expected = 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd7;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 7 (Expected = 7)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd8;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 8 (Expected 8 ^ 10 = 2)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd10;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 10 (Expected 10 ^ 10 = 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd15;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 15 (Expected 15 ^ 10 = 5)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd5;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 5 (Expected = 5)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            data = 4'd12;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input data = 12 (Expected 12 ^ 10 = 6)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_encoder Testbench");
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
        input [3:0] expected_encoded_data;
        begin
            if (expected_encoded_data === (expected_encoded_data ^ encoded_data ^ expected_encoded_data)) begin
                $display("PASS");
                $display("  Outputs: encoded_data=%h",
                         encoded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_data=%h",
                         expected_encoded_data);
                $display("  Got:      encoded_data=%h",
                         encoded_data);
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
        $dumpvars(0,clk, data, reset, encoded_data);
    end

endmodule
