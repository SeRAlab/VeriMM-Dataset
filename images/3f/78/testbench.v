`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    reg reset;
    wire data_valid;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .mosi(mosi),
        .reset(reset),
        .data_valid(data_valid),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs = 1;
            mosi = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task spi_master_send;

        input [7:0] data;
        integer i;
        begin
            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data[i];
                @(posedge clk);
                if (i > 0) @(negedge clk);
            end
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Send 0xAA", test_num);
            reset_dut();
            spi_master_send(8'hAA);

            #1;


            check_outputs(1'b1, 1'b0);
            cs = 1;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Send 0x55", test_num);
            reset_dut();
            spi_master_send(8'h55);
            #1;

            check_outputs(1'b1, 1'b1);
            cs = 1;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Send 0xFF", test_num);
            reset_dut();
            spi_master_send(8'hFF);
            #1;

            check_outputs(1'b1, 1'b1);
            cs = 1;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Send 0x00", test_num);
            reset_dut();
            spi_master_send(8'h00);
            #1;

            check_outputs(1'b1, 1'b0);
            cs = 1;
            #10;
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Partial Byte (4 bits only)", test_num);
            reset_dut();
            @(negedge clk);
            cs = 0;
            for (i = 0; i < 4; i = i + 1) begin
                mosi = 1'b1;
                @(posedge clk);
                @(negedge clk);
            end
            cs = 1;
            #10;

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
        input expected_data_valid;
        input expected_miso;
        begin
            if (expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_valid=%b, miso=%b",
                         data_valid, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_valid=%b, miso=%b",
                         expected_data_valid, expected_miso);
                $display("  Got:      data_valid=%b, miso=%b",
                         data_valid, miso);
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
        $dumpvars(0,clk, cs, mosi, reset, data_valid, miso);
    end

endmodule
