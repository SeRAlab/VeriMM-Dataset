`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] temperature;
    wire [2:0] range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .clk(clk),
        .temperature(temperature),
        .range(range)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        temperature = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Temperature 0 (Range 000)", test_num);
        temperature = 5'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Temperature 10 (Range 000)", test_num);
        temperature = 5'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Temperature 11 (Range 001)", test_num);
        temperature = 5'd11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Temperature 20 (Range 001)", test_num);
        temperature = 5'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Temperature 25 (Range 010)", test_num);
        temperature = 5'd25;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Temperature 35 (Range 011)", test_num);
        temperature = 7'd35;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Temperature 45 (Range 100)", test_num);
        temperature = 7'd45;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test %0d: Temperature 55 (Range 101)", test_num);
        temperature = 7'd55;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Test %0d: Invalid Input (>63) - Hold Previous", test_num);


        temperature = 7'd25;
        @(posedge clk);
        #1;


        temperature = 7'd70;
        @(posedge clk);
        #1;


        #1;



        check_outputs(3'b010);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        $display("Test %0d: Recovery from Invalid Input", test_num);


        temperature = 7'd80;
        @(posedge clk);
        #1;


        temperature = 7'd5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(3'b000);
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
        testcase010();
        
        
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
        input [2:0] expected_range;
        begin
            if (expected_range === (expected_range ^ range ^ expected_range)) begin
                $display("PASS");
                $display("  Outputs: range=%h",
                         range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range=%h",
                         expected_range);
                $display("  Got:      range=%h",
                         range);
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
        $dumpvars(0,clk, temperature, range);
    end

endmodule
