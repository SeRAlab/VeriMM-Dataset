`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        we = 0;
        forever #5 we = ~we;
    end

        task reset_dut;

    begin
        addr = 0;
        data_in = 0;

        @(negedge we);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write 0xA5 to Address 0", test_num);
        reset_dut();


        addr = 3'h0;
        data_in = 8'hA5;
        @(posedge we);
        @(negedge we);


        addr = 3'h0;
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write 0x5A to Address 7", test_num);
        reset_dut();


        addr = 3'h7;
        data_in = 8'h5A;
        @(posedge we);
        @(negedge we);


        addr = 3'h7;
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Address 3 (0x11 -> 0xFF)", test_num);
        reset_dut();


        addr = 3'h3;
        data_in = 8'h11;
        @(posedge we); @(negedge we);


        data_in = 8'hFF;
        @(posedge we); @(negedge we);


        addr = 3'h3;
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address Independence (Write Addr 1 and 2, Read 1)", test_num);
        reset_dut();


        addr = 3'h1; data_in = 8'hBB;
        @(posedge we); @(negedge we);


        addr = 3'h2; data_in = 8'hCC;
        @(posedge we); @(negedge we);


        addr = 3'h1;
        #2;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write/Read Zero Data", test_num);
        reset_dut();

        addr = 3'h4;
        data_in = 8'h00;
        @(posedge we); @(negedge we);

        addr = 3'h4;
        #2;
        #1;

        check_outputs(8'h00);
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
        $dumpvars(0,addr, data_in, we, data_out);
    end

endmodule
