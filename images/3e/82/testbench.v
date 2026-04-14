`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    wire [7:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .mosi(mosi),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs = 1;
            mosi = 0;
            repeat(2) @(negedge clk);
        end
        endtask
    task send_byte;

        input [7:0] byte_to_send;
        integer i;
        begin
            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = byte_to_send[i];
                @(posedge clk);
                if (i > 0) @(negedge clk);
            end
            #2;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Send 0xA5 (10100101)", test_num);
            send_byte(8'hA5);
            #1;

            check_outputs(8'hA5, 1'b1);
            cs = 1;
            #20;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Send 0x3C (00111100)", test_num);
            send_byte(8'h3C);
            #1;

            check_outputs(8'h3C, 1'b1);
            cs = 1;
            #20;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Send 0xFF (11111111)", test_num);
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1);
            cs = 1;
            #20;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Send 0x00 (00000000)", test_num);
            send_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1);
            cs = 1;
            #20;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: CS Inactive Check", test_num);
            cs = 1;
            repeat(8) begin
                mosi = 1'b1;
                @(posedge clk);
            end
            #2;

            #1;


            check_outputs(8'h00, 1'b0);
            #20;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Transmission Reset Check", test_num);


            @(negedge clk);
            cs = 0;
            repeat(4) begin
                mosi = 1'b1;
                @(posedge clk);
                @(negedge clk);
            end
            cs = 1;
            #20;


            send_byte(8'h5A);
            #1;

            check_outputs(8'h5A, 1'b1);
            cs = 1;
            #20;
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
        input [7:0] expected_data_out;
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,clk, cs, mosi, data_out, data_ready);
    end

endmodule
