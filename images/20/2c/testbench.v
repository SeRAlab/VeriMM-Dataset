`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg valid;
    wire [15:0] checksum_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .valid(valid),
        .checksum_out(checksum_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid = 0;
            data_in = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Simple Two-Word Sum", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'h0001; valid = 1;
            @(posedge clk);
            data_in = 16'h0002; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;


            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'hfffc, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Standard IP Words", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'h4500; valid = 1;
            @(posedge clk);
            data_in = 16'h003c; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'hba63, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Carry Folding", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'hffff; valid = 1;
            @(posedge clk);
            data_in = 16'h0001; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'hfffe, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Max Values Carry Folding", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'hffff; valid = 1;
            @(posedge clk);
            data_in = 16'hffff; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multiple Word Stream", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'h1234; valid = 1;
            @(posedge clk);
            data_in = 16'h5678; valid = 1;
            @(posedge clk);
            data_in = 16'h9abc; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'hfc96, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Data", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'h0000; valid = 1;
            @(posedge clk);
            data_in = 16'h0000; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'hffff, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternating Bits", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'haaaa; valid = 1;
            @(posedge clk);
            data_in = 16'h5555; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Word Only", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 16'habcd; valid = 1;
            @(posedge clk);
            valid = 0; data_in = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(16'h5432, 1'b1);
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
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_checksum_out;
        input expected_ready;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, ready=%b",
                         checksum_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, ready=%b",
                         expected_checksum_out, expected_ready);
                $display("  Got:      checksum_out=%h, ready=%b",
                         checksum_out, ready);
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
        $dumpvars(0,clk, data_in, valid, checksum_out, ready);
    end

endmodule
