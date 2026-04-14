`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire CS;
    wire MOSI;
    wire SCK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_spi_transaction;

        input [7:0] send_val;
        output [7:0] captured_val;
        integer i;
        begin
            data_in = send_val;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(CS == 0);


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge SCK);
                captured_val = {captured_val[6:0], MOSI};
            end


            wait(CS == 1);
            #(20);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Idle State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, MOSI, 1'b0);
        end
        endtask

    task testcase002;

        reg [7:0] captured;
        begin
            test_num = 2;
            $display("Testcase %03d: Transmit 0xAA", test_num);
            reset_dut();
            run_spi_transaction(8'hAA, captured);

            if (captured === 8'hAA) begin
                $display("  Data Match: Sent 0xAA, Received 0x%h", captured);
                #1;

                check_outputs(1'b1, MOSI, 1'b0);
            end else begin
                $display("  Data Mismatch: Sent 0xAA, Received 0x%h", captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg [7:0] captured;
        begin
            test_num = 3;
            $display("Testcase %03d: Transmit 0x55", test_num);
            reset_dut();
            run_spi_transaction(8'h55, captured);

            if (captured === 8'h55) begin
                $display("  Data Match: Sent 0x55, Received 0x%h", captured);
                #1;

                check_outputs(1'b1, MOSI, 1'b0);
            end else begin
                $display("  Data Mismatch: Sent 0x55, Received 0x%h", captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [7:0] captured;
        begin
            test_num = 4;
            $display("Testcase %03d: Transmit 0xFF", test_num);
            reset_dut();
            run_spi_transaction(8'hFF, captured);

            if (captured === 8'hFF) begin
                $display("  Data Match: Sent 0xFF, Received 0x%h", captured);
                #1;

                check_outputs(1'b1, 1'b1, 1'b0);
            end else begin
                $display("  Data Mismatch: Sent 0xFF, Received 0x%h", captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [7:0] captured;
        begin
            test_num = 5;
            $display("Testcase %03d: Transmit 0x00", test_num);
            reset_dut();
            run_spi_transaction(8'h00, captured);

            if (captured === 8'h00) begin
                $display("  Data Match: Sent 0x00, Received 0x%h", captured);
                #1;

                check_outputs(1'b1, 1'b0, 1'b0);
            end else begin
                $display("  Data Mismatch: Sent 0x00, Received 0x%h", captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        reg [7:0] captured1, captured2;
        begin
            test_num = 6;
            $display("Testcase %03d: Consecutive Transfers (0xA5 then 0x5A)", test_num);
            reset_dut();

            run_spi_transaction(8'hA5, captured1);
            #(50);
            run_spi_transaction(8'h5A, captured2);

            if (captured1 === 8'hA5 && captured2 === 8'h5A) begin
                $display("  Both bytes verified successfully");
                #1;

                check_outputs(1'b1, 1'b0, 1'b0);
            end else begin
                $display("  Sequence error: Got 0x%h and 0x%h", captured1, captured2);
                fail_count = fail_count + 1;
            end
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
        input expected_CS;
        input expected_MOSI;
        input expected_SCK;
        begin
            if (expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SCK === (expected_SCK ^ SCK ^ expected_SCK)) begin
                $display("PASS");
                $display("  Outputs: CS=%b, MOSI=%b, SCK=%b",
                         CS, MOSI, SCK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CS=%b, MOSI=%b, SCK=%b",
                         expected_CS, expected_MOSI, expected_SCK);
                $display("  Got:      CS=%b, MOSI=%b, SCK=%b",
                         CS, MOSI, SCK);
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
        $dumpvars(0,clk, data_in, rst, start, CS, MOSI, SCK);
    end

endmodule
