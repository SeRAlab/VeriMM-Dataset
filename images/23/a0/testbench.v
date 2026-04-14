`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst;
    reg valid;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .checksum(checksum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition (No Overflow)", test_num);
            reset_dut();

            data_in = 16'h1234; valid = 1; @(posedge clk);
            data_in = 16'h5678; valid = 1; @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h68AC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry Wrap Around", test_num);
            reset_dut();

            data_in = 16'hF000; valid = 1; @(posedge clk);
            data_in = 16'h2000; valid = 1; @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h1001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Words Accumulation", test_num);
            reset_dut();

            data_in = 16'h1111; valid = 1; @(posedge clk);
            data_in = 16'h2222; valid = 1; @(posedge clk);
            data_in = 16'h3333; valid = 1; @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h6666);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Values (All Fs)", test_num);
            reset_dut();

            data_in = 16'hFFFF; valid = 1; @(posedge clk);
            data_in = 16'hFFFF; valid = 1; @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap-around to 0x0001", test_num);
            reset_dut();

            data_in = 16'hFFFF; valid = 1; @(posedge clk);
            data_in = 16'h0001; valid = 1; @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Carries Sequence", test_num);
            reset_dut();

            data_in = 16'h8000; valid = 1; @(posedge clk);
            data_in = 16'h8000; valid = 1; @(posedge clk);
            data_in = 16'h8000; valid = 1; @(posedge clk);
            valid = 0;



            #1;




            check_outputs(16'h8001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
        $dumpvars(0,clk, data_in, rst, valid, checksum);
    end

endmodule
