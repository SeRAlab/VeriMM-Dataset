`timescale 1ns/1ps

module des_single_round_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [63:0] key;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_single_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            data_in = 64'h0000000000000000;
            key     = 64'h0000000000000000;


            #1;



            check_outputs(64'hEFA20D6D0C61A07E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            key     = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(64'hAD9C6D68666A1009);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checkerboard Pattern A", test_num);
            data_in = 64'h5555555555555555;
            key     = 64'hAAAAAAAAAAAAAAAA;

            #1;


            check_outputs(64'h296A831E002B4D01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checkerboard Pattern B", test_num);
            data_in = 64'hAAAAAAAAAAAAAAAA;
            key     = 64'h5555555555555555;

            #1;


            check_outputs(64'h992A0B10C02A8D56);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard Hex Sequence", test_num);
            data_in = 64'h0123456789ABCDEF;
            key     = 64'h133457799BBCDFF1;

            #1;


            check_outputs(64'h69C0AC20921B0B20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key Sensitivity Test", test_num);

            data_in = 64'h0123456789ABCDEF;
            key     = 64'h133457799BBCDFF0;

            #1;


            check_outputs(64'h7A11BF31A21C0C31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_single_round Testbench");
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
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
