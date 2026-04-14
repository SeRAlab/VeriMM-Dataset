`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg RE;
    reg RST;
    reg WE;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .RE(RE),
        .RST(RST),
        .WE(WE),
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
            RST = 1;
            WE = 0;
            data_in = 8'h00;
            #20;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset initial state (0x00)", test_num);

            WE = 0;

            wait(RE == 1);
            #2;
            #1;

            check_outputs(8'h00);
            #8;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 0xAA and Read", test_num);

            data_in = 8'hAA;
            WE = 1;
            #10;
            WE = 0;


            wait(RE == 1);
            #2;
            #1;

            check_outputs(8'hAA);
            #8;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 0x55 and Read", test_num);

            data_in = 8'h55;
            WE = 1;
            #10;
            WE = 0;

            wait(RE == 1);
            #2;
            #1;

            check_outputs(8'h55);
            #8;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Overwrite 0xFF with 0x12", test_num);


            data_in = 8'hFF;
            WE = 1;
            #10;

            data_in = 8'h12;
            WE = 1;
            #10;
            WE = 0;

            wait(RE == 1);
            #2;
            #1;

            check_outputs(8'h12);
            #8;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Write 0xCC then assert RST", test_num);


            data_in = 8'hCC;
            WE = 1;
            #10;
            WE = 0;


            RST = 1;
            #10;
            RST = 0;


            wait(RE == 1);
            #2;
            #1;

            check_outputs(8'h00);
            #8;
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
        $dumpvars(0,RE, RST, WE, data_in, data_out);
    end

endmodule
