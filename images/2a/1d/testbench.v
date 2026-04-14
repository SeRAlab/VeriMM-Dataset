`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg control;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        control = 0;
        forever #5 control = ~control;
    end

        task reset_dut;

        begin

            data_in = 4'b0000;

            @(posedge control);
            @(negedge control);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Write and Read (4'hA)", test_num);
            reset_dut();


            data_in = 4'hA;


            @(posedge control);

            @(negedge control);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Write and Read (4'h5)", test_num);
            reset_dut();

            data_in = 4'h5;
            @(posedge control);
            @(negedge control);

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Data Retention Test", test_num);
            reset_dut();


            data_in = 4'hC;
            @(posedge control);


            @(negedge control);


            data_in = 4'h3;
            #2;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All-Ones Boundary Test (4'hF)", test_num);
            reset_dut();

            data_in = 4'hF;
            @(posedge control);
            @(negedge control);

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Successive Write Operations", test_num);
            reset_dut();


            data_in = 4'h1;
            @(posedge control);
            @(negedge control);


            data_in = 4'hE;
            @(posedge control);
            @(negedge control);

            #1;


            check_outputs(4'hE);
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
        $dumpvars(0,control, data_in, data_out);
    end

endmodule
