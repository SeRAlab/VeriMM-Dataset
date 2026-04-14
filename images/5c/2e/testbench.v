`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] rd_addr;
    reg [7:0] wr_addr;
    reg wr_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .clk(clk),
        .data_in(data_in),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            wr_addr = 0;
            rd_addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            test_num = 1;
            reset_dut();

            wr_en = 1;
            wr_addr = 8'h0A;
            data_in = 8'h55;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_addr = 8'h0A;
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Overwrite Data");
            test_num = 2;
            reset_dut();


            wr_en = 1;
            wr_addr = 8'h10;
            data_in = 8'hAA;
            @(posedge clk);
            #1;


            data_in = 8'hBB;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_addr = 8'h10;
            #2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Verification");
            test_num = 3;
            reset_dut();


            wr_en = 1;
            wr_addr = 8'h20;
            data_in = 8'hCC;
            @(posedge clk);
            #1;


            wr_en = 0;
            data_in = 8'hDD;
            @(posedge clk);
            #1;

            rd_addr = 8'h20;
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Asynchronous Read Verification");
            test_num = 4;
            reset_dut();


            wr_en = 1;
            wr_addr = 8'h30; data_in = 8'h11; @(posedge clk); #1;
            wr_addr = 8'h31; data_in = 8'h22; @(posedge clk); #1;
            wr_en = 0;


            rd_addr = 8'h30;
            #1;
            rd_addr = 8'h31;
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Memory Boundary (Address 255)");
            test_num = 5;
            reset_dut();

            wr_en = 1;
            wr_addr = 8'hFF;
            data_in = 8'h99;
            @(posedge clk);
            #1;
            wr_en = 0;

            rd_addr = 8'hFF;
            #2;
            #1;

            check_outputs(8'h99);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram Testbench");
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rd_addr, wr_addr, wr_en, data_out);
    end

endmodule
