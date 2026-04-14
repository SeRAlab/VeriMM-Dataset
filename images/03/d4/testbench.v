`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] pin_input;
    reg reset;
    wire [4:0] pin_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .pin_input(pin_input),
        .reset(reset),
        .pin_output(pin_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pin_input = 5'b00000;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Set all pins to 1", test_num);
            reset_dut();
            pin_input = 5'b11111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern (10101)", test_num);
            reset_dut();
            pin_input = 5'b10101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverted Checkerboard Pattern (01010)", test_num);
            reset_dut();
            pin_input = 5'b01010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One Pattern (Bit 3)", test_num);
            reset_dut();
            pin_input = 5'b01000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            pin_input = 5'b11111;
            @(posedge clk);
            #2;

            reset = 1;
            #1;
            #1;

            check_outputs(5'b00000);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Cycle Sequential Update", test_num);
            reset_dut();
            pin_input = 5'b00001;
            @(posedge clk);
            #2;
            pin_input = 5'b10000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [4:0] expected_pin_output;
        begin
            if (expected_pin_output === (expected_pin_output ^ pin_output ^ expected_pin_output)) begin
                $display("PASS");
                $display("  Outputs: pin_output=%h",
                         pin_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pin_output=%h",
                         expected_pin_output);
                $display("  Got:      pin_output=%h",
                         pin_output);
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
        $dumpvars(0,clk, pin_input, reset, pin_output);
    end

endmodule
