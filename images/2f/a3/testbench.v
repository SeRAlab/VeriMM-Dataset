`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg we;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data(data),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            we = 1;
            data = 8'h00;
            @(posedge clk);
            we = 0;
            data = 8'hzz;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            we = 1;
            data = 8'hAA;
            @(posedge clk);
            we = 0;
            data = 8'h00;

            #5;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low Check", test_num);
            reset_dut();

            @(posedge clk);
            we = 0;
            data = 8'h55;
            @(posedge clk);

            #5;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence", test_num);
            reset_dut();


            @(posedge clk);
            we = 1;
            data = 8'h3C;
            @(posedge clk);
            we = 0;
            data = 8'hFF;


            repeat(3) @(posedge clk);

            #5;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            @(posedge clk);
            we = 1;
            data = 8'h11;
            @(posedge clk);


            data = 8'hEE;
            @(posedge clk);
            we = 0;

            #5;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value 0xFF", test_num);
            reset_dut();

            @(posedge clk);
            we = 1;
            data = 8'hFF;
            @(posedge clk);
            we = 0;

            #5;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid Toggle", test_num);
            reset_dut();

            @(posedge clk);
            we = 1;
            data = 8'h01;
            @(posedge clk);
            data = 8'h02;
            @(posedge clk);
            data = 8'h04;
            @(posedge clk);
            data = 8'h08;
            @(posedge clk);
            we = 0;

            #5;
            #1;

            check_outputs(8'h08);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, we, q);
    end

endmodule
