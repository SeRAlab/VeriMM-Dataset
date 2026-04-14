`timescale 1ns/1ps

module ip_checksum_calc_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg end_packet;
    wire [15:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum_calc dut (
        .data_in(data_in),
        .end_packet(end_packet),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Basic sum (0x4500 + 0x003C)");
            test_num = test_num + 1;

            rst_n = 0; data_in = 0; end_packet = 0;
            @(posedge clk); rst_n = 1; @(posedge clk);


            data_in = 16'h4500; end_packet = 0; @(posedge clk);
            data_in = 16'h003c; end_packet = 1; @(posedge clk);


            #1;



            check_outputs(16'hba63);
            end_packet = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Sum with carry (0xFFFF + 0x0001)");
            test_num = test_num + 1;
            rst_n = 0; @(posedge clk); rst_n = 1; @(posedge clk);


            data_in = 16'hFFFF; end_packet = 0; @(posedge clk);
            data_in = 16'h0001; end_packet = 1; @(posedge clk);


            #1;



            check_outputs(16'hfffe);
            end_packet = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: RFC 1071 Example");
            test_num = test_num + 1;
            rst_n = 0; @(posedge clk); rst_n = 1; @(posedge clk);


            data_in = 16'h0001; end_packet = 0; @(posedge clk);
            data_in = 16'hf203; end_packet = 0; @(posedge clk);
            data_in = 16'hf4f5; end_packet = 0; @(posedge clk);
            data_in = 16'hf6f7; end_packet = 1; @(posedge clk);






            #1;







            check_outputs(16'h220d);
            end_packet = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: All Zeros");
            test_num = test_num + 1;
            rst_n = 0; @(posedge clk); rst_n = 1; @(posedge clk);

            data_in = 16'h0000; end_packet = 0; @(posedge clk);
            data_in = 16'h0000; end_packet = 1; @(posedge clk);


            #1;



            check_outputs(16'hffff);
            end_packet = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: All Ones");
            test_num = test_num + 1;
            rst_n = 0; @(posedge clk); rst_n = 1; @(posedge clk);

            data_in = 16'hFFFF; end_packet = 0; @(posedge clk);
            data_in = 16'hFFFF; end_packet = 1; @(posedge clk);



            #1;




            check_outputs(16'h0000);
            end_packet = 0;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum_calc Testbench");
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
        input [15:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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

endmodule
