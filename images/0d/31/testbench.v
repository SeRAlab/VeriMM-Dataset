`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [4:0] data_in;
    reg mosi;
    wire [4:0] data_out;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .mosi(mosi),
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
            data_in = 5'b0;
            mosi = 0;

            repeat(2) @(negedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [4:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0, Shift in 11111", test_num);
            reset_dut();
            data_in = 5'b00000;
            pattern = 5'b11111;
            #10;
            cs = 0;
            for (i = 4; i >= 0; i = i - 1) begin
                mosi = pattern[i];
                @(posedge clk);
                @(negedge clk);
            end
            #2;

            #1;


            check_outputs(5'b11111, 1'b0);
            cs = 1;
            #10;
        end
        endtask

    task testcase002;

        integer i;
        reg [4:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 10101, Shift in 00000", test_num);
            reset_dut();
            data_in = 5'b10101;
            pattern = 5'b00000;
            #10;
            cs = 0;
            for (i = 4; i >= 0; i = i - 1) begin
                mosi = pattern[i];
                @(posedge clk);
                @(negedge clk);
            end
            #2;

            #1;


            check_outputs(5'b00000, 1'b1);
            cs = 1;
            #10;
        end
        endtask

    task testcase003;

        integer i;
        reg [4:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bidirectional Transfer (11000 <-> 01011)", test_num);
            reset_dut();
            data_in = 5'b11000;
            pattern = 5'b01011;
            #10;
            cs = 0;
            for (i = 4; i >= 0; i = i - 1) begin
                mosi = pattern[i];
                @(posedge clk);
                @(negedge clk);
            end
            #2;

            #1;


            check_outputs(5'b01011, 1'b0);
            cs = 1;
            #10;
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify CS=1 inhibits shifting", test_num);
            reset_dut();
            data_in = 5'b01110;
            #10;
            cs = 1;
            mosi = 1;

            repeat(10) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b01110, miso);
            #10;
        end
        endtask

    task testcase005;

        integer i;
        reg [4:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Pattern 10101", test_num);
            reset_dut();
            data_in = 5'b00000;
            pattern = 5'b10101;
            #10;
            cs = 0;
            for (i = 4; i >= 0; i = i - 1) begin
                mosi = pattern[i];
                @(posedge clk);
                @(negedge clk);
            end
            #2;
            #1;

            check_outputs(5'b10101, 1'b0);
            cs = 1;
            #10;
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
        input [4:0] expected_data_out;
        input expected_miso;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, miso=%b",
                         data_out, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, miso=%b",
                         expected_data_out, expected_miso);
                $display("  Got:      data_out=%h, miso=%b",
                         data_out, miso);
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
        $dumpvars(0,clk, cs, data_in, mosi, data_out, miso);
    end

endmodule
