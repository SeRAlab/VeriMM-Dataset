`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg start;
    wire data_ready;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .mosi(mosi),
        .start(start),
        .data_ready(data_ready),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            mosi = 0;

            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: All-Ones Transmission", test_num);
            reset_dut();

            start = 1;
            repeat(8) begin
                mosi = 1'b1;
                @(posedge clk);
            end
            start = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: All-Zeros Transmission", test_num);
            reset_dut();

            start = 1;
            repeat(8) begin
                mosi = 1'b0;
                @(posedge clk);
            end
            start = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Idle State Check", test_num);
            reset_dut();


            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Alternating Pattern", test_num);
            reset_dut();

            start = 1;
            repeat(4) begin
                mosi = 1'b1; @(posedge clk);
                mosi = 1'b0; @(posedge clk);
            end
            start = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d: Incomplete Transaction", test_num);
            reset_dut();

            start = 1;
            mosi = 1'b1;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_data_ready;
        input expected_miso;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, miso=%b",
                         data_ready, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, miso=%b",
                         expected_data_ready, expected_miso);
                $display("  Got:      data_ready=%b, miso=%b",
                         data_ready, miso);
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
        $dumpvars(0,clk, mosi, start, data_ready, miso);
    end

endmodule
