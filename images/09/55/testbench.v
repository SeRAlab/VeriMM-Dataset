`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [7:0] polynomial;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .data_in(data_in),
        .polynomial(polynomial),
        .crc_out(crc_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x00, Poly=0x07", test_num);
        data_in = 8'h00;
        polynomial = 8'h07;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x01, Poly=0x07", test_num);
        data_in = 8'h01;
        polynomial = 8'h07;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x80, Poly=0x07", test_num);
        data_in = 8'h80;
        polynomial = 8'h07;
        #1;

        check_outputs(8'h89);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0xFF, Poly=0x07", test_num);
        data_in = 8'hFF;
        polynomial = 8'h07;
        #1;

        check_outputs(8'hF3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0xAA, Poly=0x07", test_num);
        data_in = 8'hAA;
        polynomial = 8'h07;
        #1;

        check_outputs(8'h5F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x12, Poly=0x31", test_num);
        data_in = 8'h12;
        polynomial = 8'h31;
        #1;

        check_outputs(8'h21);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x34, Poly=0x31", test_num);
        data_in = 8'h34;
        polynomial = 8'h31;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0xFE, Poly=0x1D", test_num);
        data_in = 8'hFE;
        polynomial = 8'h1D;
        #1;

        check_outputs(8'hD9);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x23, Poly=0x9B", test_num);
        data_in = 8'h23;
        polynomial = 8'h9B;
        #1;

        check_outputs(8'h52);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=0x55, Poly=0x07", test_num);
        data_in = 8'h55;
        polynomial = 8'h07;
        #1;

        check_outputs(8'hAC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        testcase010();
        
        
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
        input [7:0] expected_crc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
