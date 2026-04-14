`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg RE;
    reg WE;
    reg [2:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .RE(RE),
        .WE(WE),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

        begin
            WE = 0;
            addr = 0;
            data_in = 0;
            @(posedge RE);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Write and Read at Address 0", test_num);


            WE = 1; addr = 3'b000; data_in = 8'hA5;
            @(posedge RE);
            #2 WE = 0;


            @(posedge RE);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Write and Read at Address 7", test_num);


            WE = 1; addr = 3'b111; data_in = 8'h5A;
            @(posedge RE);
            #2 WE = 0;


            @(posedge RE);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Verify cross-talk (Write multiple, read one)", test_num);


            WE = 1; addr = 3'b001; data_in = 8'h11;
            @(posedge RE);


            #2 addr = 3'b010; data_in = 8'h22;
            @(posedge RE);


            #2 WE = 0; addr = 3'b001;
            @(posedge RE);
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Verify Write Enable logic (WE=0 should not overwrite)", test_num);


            WE = 1; addr = 3'b100; data_in = 8'hCC;
            @(posedge RE);


            #2 WE = 0; data_in = 8'hDD;
            @(posedge RE);


            #2 addr = 3'b100;
            @(posedge RE);
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: All ones pattern (0xFF)", test_num);

            WE = 1; addr = 3'b011; data_in = 8'hFF;
            @(posedge RE);
            #2 WE = 0;

            @(posedge RE);
            #2;
            #1;

            check_outputs(8'hFF);
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
        $dumpvars(0,RE, WE, addr, data_in, data_out);
    end

endmodule
