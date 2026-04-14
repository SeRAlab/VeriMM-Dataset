`timescale 1ns/1ps

module fixed_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [31:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nStarting Test Case %0d: Zeros and Identity", test_num);


        A = 16'h0000; B = 16'h0000;
        #1;

        check_outputs(32'h00000000);


        A = 16'h0005; B = 16'h0000;
        #1;

        check_outputs(32'h00000000);


        A = 16'h0001; B = 16'h0032;
        #1;

        check_outputs(32'h00000032);



        A = 16'hFFFF; B = 16'h000A;
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nStarting Test Case %0d: Positive Values", test_num);


        A = 16'd10; B = 16'd10;
        #1;

        check_outputs(32'h00000064);


        A = 16'd128; B = 16'd256;
        #1;

        check_outputs(32'h00008000);


        A = 16'd1000; B = 16'd1000;
        #1;

        check_outputs(32'h000F4240);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nStarting Test Case %0d: Negative Values", test_num);


        A = -16'd5; B = -16'd5;
        #1;

        check_outputs(32'h00000019);


        A = -16'd100; B = 16'd50;
        #1;

        check_outputs(32'hFFFFEC78);


        A = 16'hFFFF; B = 16'hFFFF;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nStarting Test Case %0d: Boundary Conditions (Max/Min)", test_num);



        A = 16'h7FFF; B = 16'h7FFF;
        #1;

        check_outputs(32'h3FFF0001);



        A = 16'h8000; B = 16'h8000;
        #1;

        check_outputs(32'h40000000);



        A = 16'h8000; B = 16'h7FFF;
        #1;

        check_outputs(32'hC0008000);



        A = 16'h8000; B = 16'h0001;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_multiplier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
