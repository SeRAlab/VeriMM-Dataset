`timescale 1ns/1ps

module vector_sr_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [1:0] data_i;
    reg rst_i;
    wire [1:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_sr dut (
        .clk_i(clk_i),
        .data_i(data_i),
        .rst_i(rst_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            data_i = 0;
            @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(TEST_RESET_VAL);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Value Propagation", test_num);
            reset_dut();


            data_i = 2'b11;
            @(posedge clk_i);


            data_i = 2'b00;
            @(posedge clk_i);
            @(posedge clk_i);
            @(posedge clk_i);

            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Sequential Data Flow", test_num);
            reset_dut();

            @(posedge clk_i) data_i = 2'b01;
            @(posedge clk_i) data_i = 2'b10;
            @(posedge clk_i) data_i = 2'b11;
            @(posedge clk_i) data_i = 2'b11;

            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Continuous Shifting", test_num);
            reset_dut();

            @(posedge clk_i) data_i = 2'b10;
            @(posedge clk_i) data_i = 2'b01;
            @(posedge clk_i) data_i = 2'b11;
            @(posedge clk_i) data_i = 2'b00;
            @(posedge clk_i) data_i = 2'b10;

            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk_i) data_i = 2'b11;
            @(posedge clk_i) data_i = 2'b11;

            rst_i = 1;
            @(posedge clk_i);
            rst_i = 0;

            #1;
            #1;

            check_outputs(TEST_RESET_VAL);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_sr Testbench");
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
        input [1:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,clk_i, data_i, rst_i, data_o);
    end

endmodule
