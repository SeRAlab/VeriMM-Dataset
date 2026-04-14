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
        we = 0;
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
        $display("Testcase %0d: Basic Write and Read at Address 0", test_num);


        addr = 4'h0;
        data_in = 16'hAAAA;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        addr = 4'h0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Boundary Address Write and Read (Addr 15)", test_num);


        addr = 4'hF;
        data_in = 16'h5555;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        addr = 4'hF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Overwrite Data", test_num);


        addr = 4'h5;
        data_in = 16'h1234;
        we = 1;
        @(posedge clk);
        #1;


        data_in = 16'hABCD;
        @(posedge clk);
        #1;


        we = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Write Enable Verification", test_num);


        addr = 4'h3;
        data_in = 16'h7777;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        data_in = 16'hEEEE;
        @(posedge clk);
        #1;


        addr = 4'h3;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h7777);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Address Independence Check", test_num);


        addr = 4'hA;
        data_in = 16'hAFAF;
        we = 1;
        @(posedge clk);
        #1;


        addr = 4'hB;
        data_in = 16'hBFBF;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        addr = 4'hA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hAFAF);
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
