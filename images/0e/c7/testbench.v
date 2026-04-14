`timescale 1ns/1ps

module neural_network_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] expected_outputs;
    reg [2:0] inputs;
    reg reset;
    wire [1:0] outputs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network dut (
        .clk(clk),
        .expected_outputs(expected_outputs),
        .inputs(inputs),
        .reset(reset),
        .outputs(outputs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            inputs = 3'b000;
            expected_outputs = 2'b00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 3'b111 -> 2'b11", test_num);
            reset_dut();


            inputs = 3'b111;
            expected_outputs = 2'b11;


            repeat(100) @(posedge clk);


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 3'b000 -> 2'b00", test_num);
            reset_dut();

            inputs = 3'b000;
            expected_outputs = 2'b00;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 3'b101 -> 2'b10", test_num);
            reset_dut();

            inputs = 3'b101;
            expected_outputs = 2'b10;


            repeat(200) @(posedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 3'b010 -> 2'b01", test_num);
            reset_dut();

            inputs = 3'b010;
            expected_outputs = 2'b01;

            repeat(200) @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Short iteration test (Mapping 3'b110 -> 2'b11)", test_num);
            reset_dut();

            inputs = 3'b110;
            expected_outputs = 2'b11;


            repeat(20) @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_network Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_outputs;
        begin
            if (expected_outputs === (expected_outputs ^ outputs ^ expected_outputs)) begin
                $display("PASS");
                $display("  Outputs: outputs=%h",
                         outputs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputs=%h",
                         expected_outputs);
                $display("  Got:      outputs=%h",
                         outputs);
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
        $dumpvars(0,clk, expected_outputs, inputs, reset, outputs);
    end

endmodule
