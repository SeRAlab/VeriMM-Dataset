`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
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
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at address 0x0000", test_num);
            reset_dut();


            addr = 16'h0000;
            data_in = 16'hA5A5;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 16'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at address 0xFFFF", test_num);
            reset_dut();


            addr = 16'hFFFF;
            data_in = 16'h5A5A;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite data at address 0x1234", test_num);
            reset_dut();


            addr = 16'h1234;
            data_in = 16'h1111;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 16'h2222;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable low prevents writing", test_num);
            reset_dut();


            addr = 16'h000A;
            data_in = 16'hCAFE;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 16'hBEEF;
            we = 0;
            @(posedge clk);
            #1;


            addr = 16'h000A;
            we = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation (Check uniqueness)", test_num);
            reset_dut();


            addr = 16'h0001;
            data_in = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1;


            addr = 16'h0002;
            data_in = 16'hBBBB;
            we = 1;
            @(posedge clk);
            #1;


            addr = 16'h0001;
            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
