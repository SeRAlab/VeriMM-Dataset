`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mosi;
    reg reset;
    reg ss;
    wire [7:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .mosi(mosi),
        .reset(reset),
        .ss(ss),
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
            reset = 1;
            ss = 1;
            mosi = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0xA5", test_num);
            reset_dut();


            send_byte(8'hA5);




            #1;





            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sending 0x3C", test_num);
            reset_dut();

            send_byte(8'h3C);

            #1;


            check_outputs(8'h3C, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SS high during transfer", test_num);
            reset_dut();

            ss = 1;
            mosi = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interrupted transfer", test_num);
            reset_dut();


            ss = 0;
            for (i = 0; i < 4; i = i + 1) begin
                mosi = 1;
                @(posedge clk);
            end
            ss = 1;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive transfers (0xFF then 0x00)", test_num);
            reset_dut();


            send_byte(8'hFF);



            send_byte(8'h00);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during transfer", test_num);
            reset_dut();

            ss = 0;
            for (i = 0; i < 4; i = i + 1) begin
                mosi = 1;
                @(posedge clk);
            end

            reset = 1;
            @(posedge clk);
            reset = 0;
            ss = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0);
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
        $dumpvars(0,clk, mosi, reset, ss, data_out, data_ready);
    end

endmodule
