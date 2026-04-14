`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] data_in;
    wire done;
    wire mosi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .done(done),
        .mosi(mosi)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transmitting 8'h80 (MSB first assumed)", test_num);
            reset_dut();
            data_in = 8'h80;
            cs = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
            cs = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transmitting 8'h01", test_num);
            reset_dut();
            data_in = 8'h01;
            cs = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
            cs = 1;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transmitting 8'hFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            cs = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
            cs = 1;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transmitting 8'h00", test_num);
            reset_dut();
            data_in = 8'h00;
            cs = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
            cs = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transmitting 8'hAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            cs = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
            cs = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: CS High (Inactive)", test_num);
            reset_dut();
            cs = 1;
            data_in = 8'hFF;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Interrupted CS", test_num);
            reset_dut();
            data_in = 8'hFF;
            cs = 0;
            repeat(4) @(posedge clk);
            cs = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_done;
        input expected_mosi;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mosi=%b",
                         done, mosi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mosi=%b",
                         expected_done, expected_mosi);
                $display("  Got:      done=%b, mosi=%b",
                         done, mosi);
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
        $dumpvars(0,clk, cs, data_in, done, mosi);
    end

endmodule
