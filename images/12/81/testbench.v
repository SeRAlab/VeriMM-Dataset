`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg wr_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
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
            rd_en = 0;
            wr_en = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            @(negedge clk);
            wr_en = 1;
            data_in = 16'hAAAA;
            @(negedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
            rd_en = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write and Read 0x5555", test_num);

            @(negedge clk);
            wr_en = 1;
            data_in = 16'h5555;
            @(negedge clk);
            wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
            rd_en = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Data retention check (Write, Wait, Read)", test_num);


            @(negedge clk);
            wr_en = 1;
            data_in = 16'h1234;
            @(negedge clk);
            wr_en = 0;


            repeat(3) @(posedge clk);


            @(negedge clk);
            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
            rd_en = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwrite check", test_num);


            @(negedge clk);
            wr_en = 1;
            data_in = 16'hCCCC;
            @(negedge clk);


            data_in = 16'h3333;
            @(negedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3333);
            rd_en = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: All zeros boundary check", test_num);

            @(negedge clk);
            wr_en = 1;
            data_in = 16'h0000;
            @(negedge clk);
            wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
            rd_en = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: All ones boundary check", test_num);

            @(negedge clk);
            wr_en = 1;
            data_in = 16'hFFFF;
            @(negedge clk);
            wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
            rd_en = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Write Disable check", test_num);


            @(negedge clk);
            wr_en = 1;
            data_in = 16'hBEEF;
            @(negedge clk);


            wr_en = 0;
            data_in = 16'hDEAD;
            @(negedge clk);


            rd_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hBEEF);
            rd_en = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rd_en, wr_en, data_out);
    end

endmodule
