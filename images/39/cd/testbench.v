`timescale 1ns/1ps

module neural_network_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] features;
    reg rst;
    reg [1:0] target;
    wire [1:0] output_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network dut (
        .clk(clk),
        .features(features),
        .rst(rst),
        .target(target),
        .output_class(output_class)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            features = 4'b0000;
            target = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing reset and zero-feature behavior", test_num);
            reset_dut();
            features = 4'b0000;
            target = 2'b00;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 4'b1010 to target 2'b11", test_num);
            reset_dut();
            features = 4'b1010;
            target = 2'b11;

            repeat(50) @(posedge clk);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 4'b0101 to target 2'b01", test_num);
            reset_dut();
            features = 4'b0101;
            target = 2'b01;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Training pattern 4'b1100 to target 2'b10", test_num);
            reset_dut();
            features = 4'b1100;
            target = 2'b10;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Learning then verifying with target 0", test_num);
            reset_dut();


            features = 4'b1111;
            target = 2'b11;
            repeat(40) @(posedge clk);


            target = 2'b00;
            features = 4'b1111;
            repeat(2) @(posedge clk);

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
        input [1:0] expected_output_class;
        begin
            if (expected_output_class === (expected_output_class ^ output_class ^ expected_output_class)) begin
                $display("PASS");
                $display("  Outputs: output_class=%h",
                         output_class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_class=%h",
                         expected_output_class);
                $display("  Got:      output_class=%h",
                         output_class);
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
        $dumpvars(0,clk, features, rst, target, output_class);
    end

endmodule
