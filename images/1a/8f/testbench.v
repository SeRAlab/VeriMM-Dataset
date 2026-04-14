`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    wire active;
    wire [7:0] data_out;
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
        .active(active),
        .data_out(data_out),
        .miso(miso)
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

            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] data_to_send;
        begin
            $display("\nRunning testcase001: Send 0x55");
            reset_dut();
            data_to_send = 8'h55;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;



            #1;




            check_outputs(1'b0, 8'h55, miso);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] data_to_send;
        begin
            $display("\nRunning testcase002: Send 0xAA");
            reset_dut();
            data_to_send = 8'hAA;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;

            #1;


            check_outputs(1'b0, 8'hAA, miso);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data_to_send;
        begin
            $display("\nRunning testcase003: Send 0xFF");
            reset_dut();
            data_to_send = 8'hFF;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;

            #1;


            check_outputs(1'b0, 8'hFF, miso);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data_to_send;
        begin
            $display("\nRunning testcase004: Send 0x00");
            reset_dut();
            data_to_send = 8'h00;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;

            #1;


            check_outputs(1'b0, 8'h00, miso);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] data_to_send;
        begin
            $display("\nRunning testcase005: Verify 'active' signal during transmission");
            reset_dut();
            data_to_send = 8'hA5;

            @(negedge clk);
            cs = 0;


            for (i = 7; i >= 4; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end


            if (active === 1'b1) begin
                $display("Status Check: Controller is correctly active.");
            end else begin
                $display("Status Check: FAIL - active should be 1.");
            end


            for (i = 3; i >= 0; i = i - 1) begin
                mosi = data_to_send[i];
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;

            #1;


            check_outputs(1'b0, 8'hA5, miso);
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
        input expected_active;
        input [7:0] expected_data_out;
        input expected_miso;
        begin
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: active=%b, data_out=%h, miso=%b",
                         active, data_out, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, data_out=%h, miso=%b",
                         expected_active, expected_data_out, expected_miso);
                $display("  Got:      active=%b, data_out=%h, miso=%b",
                         active, data_out, miso);
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
        $dumpvars(0,clk, cs, mosi, active, data_out, miso);
    end

endmodule
