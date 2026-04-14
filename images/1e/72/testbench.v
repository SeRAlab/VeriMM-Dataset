`timescale 1ns/1ps

module cnn_convolution_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] feature_map;
    reg [8:0] filter;
    wire [7:0] output_feature_map;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cnn_convolution_2x2 dut (
        .feature_map(feature_map),
        .filter(filter),
        .output_feature_map(output_feature_map)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        feature_map = 16'h0000;
        filter = 9'h000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones (Truncation Check)", test_num);



        feature_map = 16'hFFFF;
        filter = 9'h1FF;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Corner Bit (Top-Left)", test_num);



        feature_map = 16'h8000;
        filter = 9'h1FF;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Top Row of Input Map", test_num);





        feature_map = 16'hF000;
        filter = 9'h1FF;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Left Column of Input Map", test_num);






        feature_map = 16'h8888;
        filter = 9'h1FF;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checkerboard Pattern", test_num);






        feature_map = 16'hAAAA;
        filter = 9'h1FF;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bottom-Right Corner Weight Only", test_num);




        feature_map = 16'hFFFF;
        filter = 9'h001;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Center Weight", test_num);




        feature_map = 16'h0660;
        filter = 9'h010;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Diagonal Map", test_num);






        feature_map = 16'h8421;
        filter = 9'h1FF;
        #1;

        check_outputs(8'hEB);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bottom Row of Input Map", test_num);





        feature_map = 16'h000F;
        filter = 9'h1FF;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cnn_convolution_2x2 Testbench");
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
        input [7:0] expected_output_feature_map;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_feature_map === (expected_output_feature_map ^ output_feature_map ^ expected_output_feature_map)) begin
                $display("PASS");
                $display("  Outputs: output_feature_map=%h",
                         output_feature_map);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_feature_map=%h",
                         expected_output_feature_map);
                $display("  Got:      output_feature_map=%h",
                         output_feature_map);
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
