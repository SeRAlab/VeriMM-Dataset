`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg mosi;
    wire [7:0] data_out;
    wire data_ready;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .clk(clk),
        .cs(cs),
        .mosi(mosi),
        .data_out(data_out),
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
            cs = 1;
            mosi = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 1;
            reset_dut();
            test_val = 8'hAA;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = test_val[i];
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(8'hAA, 1'b1, miso);

            @(negedge clk);
            cs = 1;
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 2;
            reset_dut();
            test_val = 8'h55;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = test_val[i];
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'h55, 1'b1, miso);

            @(negedge clk);
            cs = 1;
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 3;
            reset_dut();
            test_val = 8'hFF;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = test_val[i];
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'hFF, 1'b1, miso);

            @(negedge clk);
            cs = 1;
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 4;
            reset_dut();
            test_val = 8'h00;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = test_val[i];
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'h00, 1'b1, miso);

            @(negedge clk);
            cs = 1;
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = 5;
            reset_dut();
            test_val = 8'hC3;

            @(negedge clk);
            cs = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                mosi = test_val[i];
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(8'hC3, 1'b1, miso);

            @(negedge clk);
            cs = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
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
        input [7:0] expected_data_out;
        input expected_data_ready;
        input expected_miso;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b, miso=%b",
                         data_out, data_ready, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b, miso=%b",
                         expected_data_out, expected_data_ready, expected_miso);
                $display("  Got:      data_out=%h, data_ready=%b, miso=%b",
                         data_out, data_ready, miso);
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
        $dumpvars(0,clk, cs, mosi, data_out, data_ready, miso);
    end

endmodule
