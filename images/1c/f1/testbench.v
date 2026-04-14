`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dest_ip;
    reg [31:0] src_ip;
    wire allow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_ip(dest_ip),
        .src_ip(src_ip),
        .allow(allow)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Matching Source and Destination IP", test_num);
            src_ip  = {8'd192, 8'd168, 8'd1, 8'd10};
            dest_ip = {8'd10,  8'd0,   8'd0, 8'd5};
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Correct Source, Wrong Destination", test_num);
            src_ip  = {8'd192, 8'd168, 8'd1, 8'd10};
            dest_ip = {8'd10,  8'd0,   8'd0, 8'd1};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Wrong Source, Correct Destination", test_num);
            src_ip  = {8'd192, 8'd168, 8'd1, 8'd11};
            dest_ip = {8'd10,  8'd0,   8'd0, 8'd5};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Both Source and Destination Incorrect", test_num);
            src_ip  = 32'hFFFFFFFF;
            dest_ip = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Boundary IPs (Off by one bit)", test_num);

            src_ip  = 32'hC0A8010A;
            dest_ip = 32'h0A000004;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Swapped Source and Destination", test_num);
            src_ip  = {8'd10,  8'd0,   8'd0, 8'd5};
            dest_ip = {8'd192, 8'd168, 8'd1, 8'd10};
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_allow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allow === (expected_allow ^ allow ^ expected_allow)) begin
                $display("PASS");
                $display("  Outputs: allow=%b",
                         allow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allow=%b",
                         expected_allow);
                $display("  Got:      allow=%b",
                         allow);
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
