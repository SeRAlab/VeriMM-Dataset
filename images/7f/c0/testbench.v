`timescale 1ns/1ps

module ram_8x16_sync_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg wr_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_8x16_sync dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
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
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            addr = 4'h5;
            data_in = 8'hAA;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 4'h5;
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Memory Isolation", test_num);


            addr = 4'h0;
            data_in = 8'h11;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 4'hF;
            data_in = 8'hFF;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 4'h0;
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwrite Test", test_num);


            addr = 4'hA;
            data_in = 8'h55;
            wr_en = 1;
            @(posedge clk);
            #1;


            data_in = 8'h66;
            @(posedge clk);
            #1;


            wr_en = 0;
            #1;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable Logic", test_num);


            addr = 4'h7;
            data_in = 8'h33;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            data_in = 8'h99;
            @(posedge clk);
            #1;


            addr = 4'h7;
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin

            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Address Read", test_num);

            addr = 4'hF;
            data_in = 8'hBE;
            wr_en = 1;
            @(posedge clk);
            #1;

            wr_en = 0;
            addr = 4'hF;
            #1;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_8x16_sync Testbench");
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
        $dumpvars(0,addr, clk, data_in, wr_en, data_out);
    end

endmodule
