`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [7:0] data_in;
    wire clk_out;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk_in(clk_in),
        .data_in(data_in),
        .clk_out(clk_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            data_in = 8'h00;

            repeat (2) @(posedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Static input 0xA5", test_num);
            reset_dut();


            @(posedge clk_in);
            data_in = 8'hA5;



            @(posedge clk_out);
            @(posedge clk_out);
            #1;

            #1;


            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Static input 0x5A", test_num);
            reset_dut();

            @(posedge clk_in);
            data_in = 8'h5A;


            @(posedge clk_out);
            @(negedge clk_out);
            @(posedge clk_out);
            #1;
            #1;

            check_outputs(1'b1, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary value 0xFF", test_num);
            reset_dut();

            @(posedge clk_in);
            data_in = 8'hFF;

            @(posedge clk_out);
            @(posedge clk_out);
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary value 0x00", test_num);
            reset_dut();

            @(posedge clk_in);
            data_in = 8'h00;

            @(posedge clk_out);
            @(posedge clk_out);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Transition Sequence", test_num);
            reset_dut();


            @(posedge clk_in);
            data_in = 8'h12;


            @(posedge clk_in);
            data_in = 8'h34;


            @(posedge clk_out);
            @(posedge clk_out);
            #1;
            #1;

            check_outputs(1'b1, 8'h34);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input expected_clk_out;
        input [7:0] expected_data_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, data_out=%h",
                         clk_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, data_out=%h",
                         expected_clk_out, expected_data_out);
                $display("  Got:      clk_out=%b, data_out=%h",
                         clk_out, data_out);
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
        $dumpvars(0,clk_in, data_in, clk_out, data_out);
    end

endmodule
