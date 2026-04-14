`timescale 1ns/1ps

module piso_shift_reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] pdata;
    reg rst_n;
    wire sdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_reg_4bit dut (
        .clk(clk),
        .load(load),
        .pdata(pdata),
        .rst_n(rst_n),
        .sdata(sdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            pdata = 0;
            #15;
            rst_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Loading 4'b1011 and checking bit 0", test_num);
            reset_dut();
            pdata = 4'b1011;
            load = 1;
            @(posedge clk);
            #2 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Loading 4'b1011 and checking bit 1 after 1 shift", test_num);
            reset_dut();
            pdata = 4'b1011;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Loading 4'b1011 and checking bit 2 after 2 shifts", test_num);
            reset_dut();
            pdata = 4'b1011;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Loading 4'b1011 and checking bit 3 after 3 shifts", test_num);
            reset_dut();
            pdata = 4'b1011;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Loading 4'b0101 and checking bit 0", test_num);
            reset_dut();
            pdata = 4'b0101;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Loading 4'b0101 and checking bit 1 after 1 shift", test_num);
            reset_dut();
            pdata = 4'b0101;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Loading 4'b0000 and checking output", test_num);
            reset_dut();
            pdata = 4'b0000;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Loading 4'b1111 and checking output after shift", test_num);
            reset_dut();
            pdata = 4'b1111;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("piso_shift_reg_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_sdata;
        begin
            if (expected_sdata === (expected_sdata ^ sdata ^ expected_sdata)) begin
                $display("PASS");
                $display("  Outputs: sdata=%b",
                         sdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sdata=%b",
                         expected_sdata);
                $display("  Got:      sdata=%b",
                         sdata);
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
        $dumpvars(0,clk, load, pdata, rst_n, sdata);
    end

endmodule
