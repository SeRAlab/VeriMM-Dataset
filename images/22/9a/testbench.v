`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] input_signal;
    reg reset;
    wire [3:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .enable(enable),
        .input_signal(input_signal),
        .reset(reset),
        .output_signal(output_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            input_signal = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write (Enable=1)", test_num);
            reset_dut();

            enable = 1;
            input_signal = 4'hA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hold (Enable=0)", test_num);
            reset_dut();


            enable = 1;
            input_signal = 4'h5;
            @(posedge clk);
            #1;


            enable = 0;
            input_signal = 4'hF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Updates", test_num);
            reset_dut();

            enable = 1;
            input_signal = 4'h1;
            @(posedge clk);
            input_signal = 4'h2;
            @(posedge clk);
            input_signal = 4'h4;
            @(posedge clk);
            input_signal = 4'h8;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active operation", test_num);
            reset_dut();

            enable = 1;
            input_signal = 4'hB;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Toggle behavior", test_num);
            reset_dut();

            enable = 1;
            input_signal = 4'hC;
            @(posedge clk);
            #1;

            enable = 0;
            input_signal = 4'hD;
            @(posedge clk);
            #1;

            enable = 1;
            input_signal = 4'hE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hE);
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
        input [3:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, enable, input_signal, reset, output_signal);
    end

endmodule
