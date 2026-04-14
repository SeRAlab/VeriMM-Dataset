`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs_n;
    reg mosi;
    wire data_ready;
    wire [7:0] miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs_n(cs_n),
        .mosi(mosi),
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
            cs_n = 1;
            mosi = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin
            @(negedge clk);
            cs_n = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data[i];
                @(posedge clk);
                #1;
            end
            @(negedge clk);
            cs_n = 1;
            mosi = 0;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Sending 8'hA5", test_num);
            reset_dut();
            send_byte(8'hA5);
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sending 8'h3C", test_num);
            reset_dut();
            send_byte(8'h3C);
            #1;

            check_outputs(1'b1, 8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Sending 8'hFF", test_num);
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Sending 8'h00", test_num);
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Verify CS inactivity", test_num);
            reset_dut();
            cs_n = 1;
            mosi = 1;
            repeat (8) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00);
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
        input [7:0] expected_miso;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, miso=%h",
                         data_ready, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, miso=%h",
                         expected_data_ready, expected_miso);
                $display("  Got:      data_ready=%b, miso=%h",
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
        $dumpvars(0,clk, cs_n, mosi, data_ready, miso);
    end

endmodule
