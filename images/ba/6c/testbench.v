`timescale 1ns/1ps

module ram_256x10_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [9:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [9:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_256x10 dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
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
            rd_en = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            addr = 8'h55;
            data_in = 10'h2AA;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(10'h2AA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Min (0x00)", test_num);
            reset_dut();


            @(posedge clk);
            addr = 8'h00;
            data_in = 10'h3FF;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Max (0xFF)", test_num);
            reset_dut();


            @(posedge clk);
            addr = 8'hFF;
            data_in = 10'h155;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(10'h155);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify wr_en Gating", test_num);
            reset_dut();


            @(posedge clk);
            addr = 8'h10;
            data_in = 10'h0A5;
            wr_en = 1;
            @(posedge clk);


            data_in = 10'h3FF;
            wr_en = 0;
            @(posedge clk);


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(10'h0A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Sequential Accesses", test_num);
            reset_dut();


            @(posedge clk);
            addr = 8'd10; data_in = 10'd100; wr_en = 1;
            @(posedge clk);
            addr = 8'd11; data_in = 10'd200; wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            addr = 8'd10; rd_en = 1;
            @(posedge clk);
            #1;




            addr = 8'd11; rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;

            #1;


            check_outputs(10'd200);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_256x10 Testbench");
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
        input [9:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, rd_en, wr_en, data_out);
    end

endmodule
