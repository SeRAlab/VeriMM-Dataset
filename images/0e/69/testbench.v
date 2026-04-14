`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] temperature;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .clk(clk),
        .temperature(temperature),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            temperature <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 0", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd5;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 5", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd10;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 10", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd11;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 11", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd15;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 15", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd20;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 20", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd21;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 21", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd25;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 25", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            temperature <= 5'd31;
            @(posedge clk);
            #1;
            $display("Test %0d: Input Temperature = 31", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,clk, temperature, status);
    end

endmodule
