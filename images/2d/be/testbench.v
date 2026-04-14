`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

        begin
            data_in = 4'h0;

            @(posedge write_enable);
            @(negedge write_enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write and Read 4'hA", test_num);
            reset_dut();
            data_in = 4'hA;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write and Read 4'h5", test_num);
            reset_dut();
            data_in = 4'h5;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write and Read 4'hF (All High)", test_num);
            reset_dut();
            data_in = 4'hF;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write and Read 4'h0 (All Low)", test_num);
            reset_dut();
            data_in = 4'h0;

            data_in = 4'hE;
            @(negedge write_enable);
            data_in = 4'h0;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Retention (Read Mode Stability)", test_num);
            reset_dut();


            data_in = 4'hC;
            @(negedge write_enable);


            data_in = 4'h3;
            #2;


            #1;



            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Consecutive Writes", test_num);
            reset_dut();

            data_in = 4'h1;
            @(negedge write_enable);
            data_in = 4'h2;
            @(negedge write_enable);
            data_in = 4'h4;
            @(negedge write_enable);
            data_in = 4'h8;
            @(negedge write_enable);

            #2;
            #1;

            check_outputs(4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,data_in, write_enable, data_out);
    end

endmodule
