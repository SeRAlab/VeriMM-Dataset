`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            clk = 0;
            data_in = 0;
            we = 0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write 0xAAAA to Address 0", test_num);


            we = 1;
            addr = 4'h0;
            data_in = 16'hAAAA;
            @(posedge clk);


            #1;
            we = 0;
            addr = 4'h0;
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write 0x5555 to Address 15", test_num);


            we = 1;
            addr = 4'hF;
            data_in = 16'h5555;
            @(posedge clk);


            #1;
            we = 0;
            addr = 4'hF;
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwrite Address 5", test_num);


            we = 1; addr = 4'h5; data_in = 16'h1234;
            @(posedge clk);


            #1;
            we = 1; addr = 4'h5; data_in = 16'h9876;
            @(posedge clk);


            #1;
            we = 0;
            addr = 4'h5;
            #1;
            #1;

            check_outputs(16'h9876);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Verify address independence", test_num);


            we = 1; addr = 4'h2; data_in = 16'hBBBB;
            @(posedge clk);


            #1;
            we = 1; addr = 4'h3; data_in = 16'hCCCC;
            @(posedge clk);


            #1;
            we = 0;
            addr = 4'h2;
            #1;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Verify Write Enable low prevents writing", test_num);


            we = 1; addr = 4'hA; data_in = 16'h7777;
            @(posedge clk);


            #1;
            we = 0; addr = 4'hA; data_in = 16'hFFFF;
            @(posedge clk);


            #1;
            addr = 4'hA;
            #1;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Rapid successive writes", test_num);

            we = 1;
            addr = 4'h1; data_in = 16'h0001; @(posedge clk); #1;
            addr = 4'h2; data_in = 16'h0002; @(posedge clk); #1;
            addr = 4'h3; data_in = 16'h0003; @(posedge clk); #1;

            we = 0;
            addr = 4'h2;
            #1;
            #1;

            check_outputs(16'h0002);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
